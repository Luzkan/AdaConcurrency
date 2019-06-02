with Gnat.Io; use Gnat.Io;
with Ada.Numerics.Discrete_Random;
with T_Stack; use T_Stack;
with P_Stack; use P_Stack;
with F_Stack; use F_Stack;
with Config;

procedure main is

   -- St is Magazine of Todos / Sp is Magazine of Products / Sf is List of Broken Machines
   St: Todo_Stack;
   Sp: Product_Stack;
   Sf: Fix_Stack;

   -- Random Action
   Action: array (0..1) of Actions := ('+', '*');
   subtype NumOfOperations is Integer range 0..1;
   package RandomAction is new Ada.Numerics.Discrete_Random(NumOfOperations);
   RandAction: RandomAction.Generator;

   -- Random Args
   -- Boss Numbers
   subtype BossRange is Integer range 1..1000;
   package RandomArg is new Ada.Numerics.Discrete_Random(BossRange);
   RandNum: RandomArg.Generator;

   -- Worker Patience
   subtype BehaviorRange is Integer range 0..1;
   package RandomBehavior is new Ada.Numerics.Discrete_Random(BehaviorRange);
   RandBeh: RandomBehavior.Generator;

   -- Chance to break
   subtype BreakChance is Integer range 0..100;
   package RandomDamage is new Ada.Numerics.Discrete_Random(BreakChance);
   RandDmg: RandomDamage.Generator;

   -- Needs to be accesed by Boss and Worker
   TaskFromBoss: Todo;

   -- Tasks
   task type Boss;

   task type Worker is
      entry Id (workerID : in Integer);
      entry JobsDone (jobsDone : in Integer);
      entry Behavior (patient : in Boolean);
      entry AlertDone (alert: in Boolean);
      entry PrintStats;
   end Worker;

   task type Customer is
      entry Id (customerId : Integer);
   end Customer;

   -- Pointer for Machines
   -- https://en.wikibooks.org/wiki/Ada_Programming/Types/access
   type TodoPointer is access Todo;

   type Machine is
      record
         aTodoPointer: TodoPointer;
         workerID: Integer;
      end record;

   -- Machines predeclaration
   task type AddMachine is
      entry Id (AddMachineId: in Integer);
      entry NewJobs (NewJob: in Machine);
      entry Fix;
   end AddMachine;

   task type MulMachine is
      entry Id (MulMachineId: in Integer);
      entry NewJobs (NewJob: in Machine);
      entry Fix;
   end MulMachine;

   -- Repair Manager
   task type Repairmen is
      entry Id (repairmenId : Integer);
   end Repairmen;
   task RepairFacility is
      entry ToRepair(machineId: in Integer; MachineType: in Integer);
      entry RepairThis(machineId: out Integer; MachineType: out Integer);
      entry DoneRepair(machineId: in Integer; MachineType: in Integer);
   end RepairFacility;

   -- Prep to turn on the MathBusiness
   hereComesThatBoss : Boss;
   WorkNum : array (0 .. Config.WorkNum) of Worker;
   CustNum : array (0 .. Config.CustNum) of Customer;
   addMachines : array (0 .. Config.AddMachNum) of AddMachine;
   mulMachines : array (0 .. Config.MulMachNum) of MulMachine;
   repairWorkNum : array (0 .. Config.RepairWorkNum) of Repairmen;

   Command : String(1..10);
   Last : Natural;


   -- Machines
   -- They are working by getting pointer to a todo given by a Worker
   -- After they finish calculating the task, they notify worker that job is finished
   -- Adding Machine
   task body AddMachine is
      Identifier: Integer;
      CurrentJob: Machine;
      Damaged: Boolean := false;
   begin
      accept Id (AddMachineId: in Integer) do
         Identifier := AddMachineId;
      end Id;
      loop

         -- Backdoor for repairmens
         select
            accept Fix do
               Damaged := false;
            end Fix;
         else
            null;
         end select;

         -- Rand for damaging the machine with this usage
         if not Damaged and RandomDamage.Random(RandDmg) < Config.MechFailure then
            Damaged := true;
         end if;

         accept NewJobs(NewJob: in Machine) do
            CurrentJob := NewJob;
         end NewJobs;

         if not Config.Silent then
            Put_Line("[Mach] Machine with ID [" & Integer'Image(Identifier) & " ] added these two integeres: [" & Integer'Image(CurrentJob.aTodoPointer.arg1) & Integer'Image(CurrentJob.aTodoPointer.arg2) & " ]");
         end if;
         delay Config.MachPerf;

         -- Value based on machine status
         if Damaged then
            CurrentJob.aTodoPointer.answer := Config.BrokenValue;
         else
            CurrentJob.aTodoPointer.answer := CurrentJob.aTodoPointer.arg1 + CurrentJob.aTodoPointer.arg2;
         end if;

         if not Config.Silent then
            Put_Line("[Mach] Caclculated: [" & Integer'Image(CurrentJob.aTodoPointer.answer) & " ]");
         end if;

         WorkNum(CurrentJob.workerID).AlertDone(True);

      end loop;
   end AddMachine;

   -- Multiplaying Machine
   task body MulMachine is
      Identifier: Integer;
      CurrentJob: Machine;
      Damaged: Boolean := false;
   begin
      accept Id (MulMachineId: in Integer) do
         Identifier := MulMachineId;
      end Id;
      loop

         -- Backdoor for repairmens
         select
            accept Fix do
               Damaged := false;
            end Fix;
         else
            null;
         end select;

         -- Rand for damaging the machine with this usage
         if not Damaged and RandomDamage.Random(RandDmg) < Config.MechFailure then
            Damaged := true;
         end if;

         accept NewJobs(NewJob: in Machine) do
            CurrentJob := NewJob;
         end NewJobs;

         accept NewJobs(NewJob: in Machine) do
            CurrentJob := NewJob;
         end NewJobs;

         if not Config.Silent then
            Put_Line("[Mach] Machine with ID [" & Integer'Image(Identifier) & " ] multiplied these two integeres: [" & Integer'Image(CurrentJob.aTodoPointer.arg1) & Integer'Image(CurrentJob.aTodoPointer.arg2) & " ]");
         end if;
         delay Config.MachPerf;

         -- Value based on machine status
         if Damaged then
            CurrentJob.aTodoPointer.answer := Config.BrokenValue;
         else
            CurrentJob.aTodoPointer.answer := CurrentJob.aTodoPointer.arg1 * CurrentJob.aTodoPointer.arg2;
         end if;

         if not Config.Silent then
            Put_Line("[Mach] Caclculated: [" & Integer'Image(CurrentJob.aTodoPointer.answer) & " ]");
         end if;

         WorkNum(CurrentJob.workerID).AlertDone(True);

      end loop;
   end MulMachine;


   -- People
   -- Boss    - Generates tasks (todos) for worker to be solved by using random number generator.
   --           Task is placed in TasksMagazine (Todo Stack)
   task body Boss is
   begin
      bossyLoop:
      loop

         TaskFromBoss := (RandomArg.Random(RandNum), Action(RandomAction.Random(RandAction)), RandomArg.Random(RandNum), 0);
         PushT(St, TaskFromBoss);

         if not Config.Silent then
            Put_Line("[Boss] Boss created new task: " & Integer'Image(TaskFromBoss.arg1) & " " & Actions'Image(TaskFromBoss.action) & "" & Integer'Image(TaskFromBoss.arg2) & "");
         end if;

         delay Config.BossPerf;
      end loop bossyLoop;
   end Boss;

   -- Worker  - Gets the tasks from the Tasks Magazine and chooses random Machine.
   --           Based on his birth behavior (patient/unpatient) he will either stand in que
   --           or run around all machines until he gets to an empty on.
   --           He will solve the task on said machine and put it to the Product Magazine (Product Stack)
   task body Worker is
      Identifier: Integer;
      Patience: Boolean;
      FinishedTasks: Integer := 0;

      CurrentTodoPointer: TodoPointer;
      Product: Integer;

      subtype AmountAddMachines is Integer range 0..Config.AddMachNum;
      package RAddMachines is new Ada.Numerics.Discrete_Random(AmountAddMachines);
      RandAddMachine: RAddMachines.Generator;

      subtype AmountRandMulMachine is Integer range 0..Config.MulMachNum;
      package RMulMachine is new Ada.Numerics.Discrete_Random(AmountRandMulMachine);
      RandMulMachine: RMulMachine.Generator;

      goToMachine: Integer;
      gotAnswer: Boolean := false;
   begin
      accept Id (workerID: in Integer) do
         Identifier := workerID;
      end Id;
      accept JobsDone (jobsDone: in Integer) do
         FinishedTasks := jobsDone;
      end JobsDone;
      accept Behavior (patient: in Boolean) do
         Patience := patient;
      end Behavior;
      workLoop:
      loop
         PopT(St, TaskFromBoss);

         -- Stats of workers in the company are going to be printed when they will have spare time between doing tasks
         --       in other words, it can take a bit of time due to Worker being busy with doing Todo
         select
            accept PrintStats do
               Put_Line("Worker " & Integer'Image(Identifier) & " patience: " & Boolean'Image(Patience) & ". So far made: " & Integer'Image(FinishedTasks));
            end PrintStats;
         else
            null;
         end select;

         case TaskFromBoss.action is
            when '+' =>

               -- Not Patient
               if not Patience then
                  gotAnswer := false;
                  goToMachine := 0;
                  while not gotAnswer loop

                     CurrentTodoPointer := new Todo'(TaskFromBoss.arg1, TaskFromBoss.action, TaskFromBoss.arg2, TaskFromBoss.answer);
                     addMachines(goToMachine).NewJobs((CurrentTodoPointer, Identifier));

                     select
                        accept AlertDone(alert: in Boolean) do
                           Product := CurrentTodoPointer.answer;
                           gotAnswer := alert;
                        end AlertDone;
                     or
                        delay Config.WorkPat;
                     end select;

                     -- If statement to know which machine got broken if it got broken
                     if not gotAnswer then
                        goToMachine := goToMachine + 1;
                        goToMachine := goToMachine mod Config.AddMachNum;
                     end if;
                  end loop;

                -- Patient
               else
                  goToMachine := RAddMachines.Random(RandAddMachine);
                  CurrentTodoPointer := new Todo'(TaskFromBoss.arg1, TaskFromBoss.action, TaskFromBoss.arg2, TaskFromBoss.answer);
                  addMachines(goToMachine).NewJobs((CurrentTodoPointer, Identifier));

                  gotAnswer := false;
                  while not gotAnswer loop
                     select
                        accept AlertDone(alert: in Boolean) do
                           Product := CurrentTodoPointer.answer;
                           gotAnswer := alert;
                        end AlertDone;
                     end select;
                  end loop;
               end if;

               if Product = Config.BrokenValue then
                  if not Config.Silent then
                     Put_Line("[Errr] Worker spotted and reported broken adding machine. [" & Integer'Image(gotoMachine) & " ]");
                  end if;
                  RepairFacility.ToRepair(goToMachine, 1);
               end if;

            when '*' =>

               -- Not Patient
               if not Patience then
                  gotAnswer := false;
                  goToMachine := 0;
                  while not gotAnswer loop

                     CurrentTodoPointer := new Todo'(TaskFromBoss.arg1, TaskFromBoss.action, TaskFromBoss.arg2, TaskFromBoss.answer);
                     mulMachines(goToMachine).NewJobs((CurrentTodoPointer, Identifier));

                     select
                        accept AlertDone(alert: in Boolean) do
                           Product := CurrentTodoPointer.answer;
                           gotAnswer := alert;
                        end AlertDone;
                     or
                        delay Config.WorkPat;
                     end select;

                     -- If statement to know which machine got broken if it got broken
                     if not gotAnswer then
                        goToMachine := goToMachine + 1;
                        goToMachine := goToMachine mod Config.MulMachNum;
                     end if;
                  end loop;

                  -- Patient
               else
                  goToMachine := RMulMachine.Random(RandMulMachine);
                  CurrentTodoPointer := new Todo'(TaskFromBoss.arg1, TaskFromBoss.action, TaskFromBoss.arg2, TaskFromBoss.answer);
                  mulMachines(goToMachine).NewJobs((CurrentTodoPointer, Identifier));

                  gotAnswer := false;
                  while not gotAnswer loop
                     select
                        accept AlertDone(alert: in Boolean) do
                           Product := CurrentTodoPointer.answer;
                           gotAnswer := alert;
                        end AlertDone;
                     end select;
                  end loop;
               end if;

               if Product = Config.BrokenValue then
                  if not Config.Silent then
                     Put_Line("[Errr] Worker spotted and reported broken multiplaying machine. [" & Integer'Image(gotoMachine) & " ]");
                  end if;
                  RepairFacility.ToRepair(goToMachine, 2);
               end if;

         end case;

         if Product /= Config.BrokenValue then
            PushP(Sp, Product);
            FinishedTasks := FinishedTasks + 1;

            if not Config.Silent then
               Put_Line("[Work] Worker [" & Integer'Image(Identifier) & " ] created product: " & Integer'Image(Product) & "");
            end if;
         end if;

         delay Config.WorkPerf;
      end loop workLoop;
   end Worker;

   -- Repairment Facility
   task body RepairFacility is
      MachOnList : RepairMach;
      examineMachine: Integer;
      prepareMachine: RepairMach;
   begin
      loop
         select
            when not FullF(Sf) =>
               accept ToRepair(MachineId: in Integer; MachineType: in Integer) do
                  examineMachine := BrowseF(Sf, (MachineId, MachineType));

                  -- If its not on the list yet
                  if examineMachine = Config.NotOnList then
                     prepareMachine := (MachineId, MachineType);
                     -- Add it to the list
                     PushF(Sf, prepareMachine);
                     if not Config.Silent then
                        Put_Line("[FRep] New Machine added to repair list." & "ID:" &  Integer'Image(MachineId) & "Type:" &  Integer'Image(MachineType));
                     end if;
                  end if;
               end ToRepair;
         or
            accept RepairThis(MachineId: out Integer; MachineType: out Integer) do
               -- Pop from stack

               PopF(Sf, MachOnList);

               MachineId := MachOnList.MachineId;
               MachineType := MachOnList.MachineType;
               if not Config.Silent then
                  Put_Line("[Repd] Machine is being handled by repairman.");
               end if;
            end RepairThis;
         or
            accept DoneRepair(MachineId: in Integer; MachineType: in Integer) do
               if not Config.Silent then
                  Put_Line("[FRep] Machine was repaired by a repairmen: " & "ID:" & Integer'Image(MachineId) & "Type:" & Integer'Image(MachineType));
               end if;
            end DoneRepair;
         end select;
      end loop;
   end RepairFacility;


   -- Repairman
   task body Repairmen is
      Identifier: Integer;
      fixMachineId: Integer;
      fixMachineType: Integer;
   begin
      accept Id (repairmenId: in Integer) do
         Identifier := repairmenId;
      end Id;

      repairLoop:
      loop
         -- Look for Machine R repair
         if not EmptyF(Sf) then
            RepairFacility.RepairThis(fixMachineId, fixMachineType);
            if fixMachineType = 1 then
               addMachines(fixMachineId).Fix;
            else
               mulMachines(fixMachineId).Fix;
            end if;

            -- Inform the Facility that the machine was repaired
            RepairFacility.DoneRepair(fixMachineId, fixMachineType);
            --if not Config.Silent then
            --   Put_Line("[Repd] Machine was repaired: " & Integer'Image(fixMachineId));
            --end if;
         end if;
         delay Config.RepairWorkPerf;
      end loop repairLoop;
   end Repairmen;

   -- Customer
   task body Customer is
      Identifier : Integer;
      Bought: Integer;
   begin
      accept Id (customerId: in Integer) do
         Identifier := customerId;
      end Id;

      buyLoop:
      loop

         PopP(Sp, Bought);

         if not Config.Silent then
            if Bought /= 0 then
               Put_Line("[Cust] Customer bought: " & Integer'Image(Bought) & "");
            end if;
         end if;

         delay Config.CustPerf;
      end loop buyLoop;
   end Customer;

begin

   Put_Line("Starting MathBusiness");

   for I in addMachines'Range loop
      addMachines(I).Id(I);
   end loop;

   for I in mulMachines'Range loop
      mulMachines(I).Id(I);
   end loop;

   delay Config.WorkPerf;

   for I in CustNum'Range loop
      CustNum(I).Id(I);
   end loop;

   for I in RepairWorkNum'Range loop
      repairWorkNum(I).Id(I);
   end loop;

   for I in WorkNum'Range loop
      WorkNum(I).Id(I);
      WorkNum(I).JobsDone(0);
      if RandomBehavior.Random(RandBeh) = 1 then
         WorkNum(I).Behavior(False);
      else
         WorkNum(I).Behavior(True);
      end if;
   end loop;

   if Config.Silent then
      Put_Line("Silent Mode Activated.");
      Put_Line("tasks - Prints the content of task magazine.");
      Put_Line("products - Prints the content of products in the shop.");
      Put_Line("workers - Prints info about workers in the company.");
      Put_Line("broken - Prints info about broken machines.");
      loop
         Get_Line(Command, Last);

         case Command(1) is
            when 't' =>
               PrintT(St);
            when 'p' =>
               PrintP(Sp);
            when 'b' =>
               PrintF(Sf);
            when 'w' =>
               for I in WorkNum'Range loop
                  WorkNum(I).PrintStats;
               end loop;
            when others =>
               Put_Line("You misspelled a command. Try again.");
         end case;

      end loop;
   end if;

end main;

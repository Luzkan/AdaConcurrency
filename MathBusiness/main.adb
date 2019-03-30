with Gnat.Io; use Gnat.Io;
with Ada.Numerics.Discrete_Random;
with T_Stack; use T_Stack;
with P_Stack; use P_Stack;
with Config;

procedure main is

   -- St is Magazine of Todos / Sp is Magazine of Products
   St: Todo_Stack;
   Sp: Product_Stack;

   -- Random Action
   Action: array (0..2) of Actions := ('+', '-', '*');
   subtype NumOfOperations is Integer range 0..2;
   package RandomAction is new Ada.Numerics.Discrete_Random(NumOfOperations);
   RandAction: RandomAction.Generator;

   -- Random Args
   subtype BossRange is Integer range 1..1000;
   package RandomArg is new Ada.Numerics.Discrete_Random(BossRange);
   RandNum: RandomArg.Generator;

   -- Needs to be accesed by Boss and Worker
   TaskFromBoss: Todo;


   -- Tasks
   task type Boss;

   task type Worker is
      entry Id (workerId : in Integer);
   end Worker;

   task type Customer is
      entry Id (customerId : Integer);
   end Customer;

   -- Here they come
   task body Boss is
   begin
      bossyLoop:
      loop

         TaskFromBoss := (RandomArg.Random(RandNum), Action(RandomAction.Random(RandAction)), RandomArg.Random(RandNum));
         PushT(St, TaskFromBoss);

         if not Config.Silent then
            Put_Line("Boss created task: " & Integer'Image(TaskFromBoss.arg1) & " " & Actions'Image(TaskFromBoss.action) & " " & Integer'Image(TaskFromBoss.arg2) & "");
         end if;

         delay Config.BossPerf;
      end loop bossyLoop;
   end Boss;

   task body Worker is
      Identifier : Integer;
      Product: Integer;
   begin
      accept Id (workerId: in Integer) do
         Identifier := workerId;
      end Id;
      workLoop:
      loop

         PopT(St, TaskFromBoss);

         case TaskFromBoss.action is
            when '+' =>
                Product := TaskFromBoss.arg1 + TaskFromBoss.arg2;
            when '-' =>
                Product := TaskFromBoss.arg1 - TaskFromBoss.arg2;
            when '*' =>
                Product := TaskFromBoss.arg1 * TaskFromBoss.arg2;
            end case;

         PushP(Sp, Product);

         if not Config.Silent then
            Put_Line("Worker created product: " & Integer'Image(Product) & "");
         end if;

         delay Config.WorkPerf;
      end loop workLoop;
   end Worker;

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
            Put_Line("Customer bought: " & Integer'Image(Bought) & "");
         end if;

         delay Config.CustPerf;
      end loop buyLoop;
   end Customer;


   -- Prep to turn on the MathBusiness
   hereComesThatBoss : Boss;
   WorkNum : array (0 .. Config.WorkNum) of Worker;
   CustNum : array (0 .. Config.CustNum) of Customer;
   Command : String(1..10);
   Last : Natural;

begin

   Put_Line("Starting MathBusiness");

   for I in WorkNum'Range loop
      WorkNum(I).Id(I);
   end loop;

   for I in CustNum'Range loop
      CustNum(I).Id(I);
   end loop;

   if Config.Silent then
      Put_Line("Silent Mode Activated.");
      Put_Line("tasks - Prints the content of task magazine.");
      Put_Line("products - Prints the content of products in the shop.");
      loop
         Get_Line(Command, Last);

         case Command(1) is
            when 't' =>
               PrintT(St);
            when 'p' =>
               PrintP(Sp);
            when others =>
               Put_Line("You misspelled a command. Try again.");
         end case;

      end loop;
   end if;

end main;

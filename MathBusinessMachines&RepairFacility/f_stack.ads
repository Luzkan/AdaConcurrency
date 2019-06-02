package F_Stack is

   -- Fix_Stack contains products (which are ints - the results of Todo by Boss)
   type Fix_Stack is private;
   type RepairMach is
      record
         MachineId: Integer;
         MachineType: Integer;
      end record;

   Max_Size: constant Integer := 20;

   procedure PushF(S: in out Fix_Stack; I: RepairMach);
   procedure PopF(S: in out Fix_Stack; I: out RepairMach);
   function TopF(S: Fix_Stack) return RepairMach;
   function EmptyF(S: Fix_Stack) return Boolean;
   function FullF(S: Fix_Stack) return Boolean;
   procedure CleanF(S: in out Fix_Stack);
   procedure PrintF(S: in out Fix_Stack);
   function BrowseF(S: in out Fix_Stack; lookFor: RepairMach) return Integer;

   private
      type Stack_Data_Type is array(1..Max_Size) of RepairMach;
      type Fix_Stack is record
         Size: Integer := 0;
         Data: Stack_Data_Type;
      end record;

end F_Stack;

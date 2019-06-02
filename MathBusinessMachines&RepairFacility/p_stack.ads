package P_Stack is

   -- P_Stack contains products (which are ints - the results of Todo by Boss)
   type Product_Stack is private;

   Max_Size: constant Integer := 500;

   procedure PushP(S: in out Product_Stack; I: Integer);
   procedure PopP(S: in out Product_Stack; I: out Integer);
   function TopP(S: Product_Stack) return Integer;
   function EmptyP(S: Product_Stack) return Boolean;
   function FullP(S: Product_Stack) return Boolean;
   procedure CleanP(S: in out Product_Stack);
   procedure PrintP(S: in out Product_Stack);

   private
      type Stack_Data_Type is array(1..Max_Size) of Integer;
      type Product_Stack is record
         Size: Integer := 0;
         Data: Stack_Data_Type;
      end record;

end P_Stack;

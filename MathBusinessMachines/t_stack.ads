with Gnat.Io; use Gnat.Io;

package T_Stack is

   -- T_Stack contains structs which were created by boss (int, action, int)
   type Todo_Stack is private;

   Max_Size: constant Integer := 500;
   type Actions is ('+', '-', '*');
   type Todo is
         record arg1: Integer; action: Actions; arg2: Integer; end record;

   procedure PushT(S: in out Todo_Stack; I: Todo);
   procedure PopT(S: in out Todo_Stack; I: out Todo);
   procedure CleanT(S: in out Todo_Stack);
   procedure PrintT(S: in out Todo_Stack);
   function TopT(S: Todo_Stack) return Todo;
   function EmptyT(S: Todo_Stack) return Boolean;
   function FullT(S: Todo_Stack) return Boolean;

   private
      type Stack_Data_Type is array(1..Max_Size) of Todo;
      type Todo_Stack is record
         Size: Integer := 0;
         Data: Stack_Data_Type;
      end record;

end T_Stack;

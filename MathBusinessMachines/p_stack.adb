with Gnat.Io; use Gnat.Io;

package body P_Stack is
   
   -- Push an integer. If the stack is already full, ignore the push.
   procedure PushP(S: in out Product_Stack; I: Integer) is
   begin
      if S.Size < Max_Size then
         S.Size := S.Size + 1;
         S.Data(S.Size) := I;
      end if;
   end PushP;

   -- Pop and integer.  If the stack is empty, a zero is placed in I.
   procedure PopP(S: in out Product_Stack; I: out Integer) is
   begin
      if S.Size > 0 then
         I := S.Data(S.Size);
         S.Size := S.Size - 1;
      end if;
   end PopP;
   
   -- Make the stack empty.
   procedure CleanP(S: in out Product_Stack) is
   begin
      S.Size := 0;
   end CleanP;
   
   -- Print the stack.
   procedure PrintP(S: in out Product_Stack) is
      I: Integer;
      K: Integer := 0;
   begin
      while (S.Size - K) > 0 loop
         
         I := S.Data(S.Size - k);
         Put_Line("Stack Prints: " & Integer'Image(I) & "");
         K := K + 1;
         
      end loop;
   end PrintP;
   
   -- These below ended up unused but could be usefull in future
   -- Get the top item, or 0 if the stack is empty.
   function TopP(S: Product_Stack) return Integer is
   begin
      if S.Size > 0 then
         return S.Data(S.Size);
      else
         return 0;
      end if;
   end TopP;

   -- Tell if the stack is empty.
   function EmptyP(S: Product_Stack) return Boolean is
   begin
      return S.Size = 0;
   end EmptyP;

   -- Tell if the stack is empty.
   function FullP(S: Product_Stack) return Boolean is
   begin
      return S.Size = Max_Size;
   end FullP;
   
end P_Stack;

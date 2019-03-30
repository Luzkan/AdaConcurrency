
package body T_Stack is
   -- Push an integer. If the stack is already full, ignore the push.
   procedure PushT(S: in out Todo_Stack; I: Todo) is
   begin
      if S.Size < Max_Size then
         S.Size := S.Size + 1;
         S.Data(S.Size) := I;
      end if;
   end PushT;

   -- Pop and integer. If the stack is empty, a zero is placed in I.
   procedure PopT(S: in out Todo_Stack; I: out Todo) is
   begin
      if S.Size > 0 then
         I := S.Data(S.Size);
         S.Size := S.Size - 1;
      end if;
   end PopT;

   -- Get the top item, or Task (0+0) if the stack is empty.
   function TopT(S: Todo_Stack) return Todo is
   begin
      if S.Size > 0 then
         return S.Data(S.Size);
      else
         return (0, '+', 0);
      end if;
   end TopT;

   -- Tell if the stack is empty.
   function EmptyT(S: Todo_Stack) return Boolean is
   begin
      return S.Size = 0;
   end EmptyT;

   -- Tell if the stack is empty.
   function FullT(S: Todo_Stack) return Boolean is
   begin
      return S.Size = Max_Size;
   end FullT;

   -- Make the stack empty.
   procedure CleanT(S: in out Todo_Stack) is
   begin
      S.Size := 0;
   end CleanT;

   -- Print the stack.
   procedure PrintT(S: in out Todo_Stack) is
      I: Todo;
      K: Integer := 0;
   begin
      while (S.Size - K) > 0 loop

         I := S.Data(S.Size - k);
         Put_Line("Stack Prints: " & Integer'Image(I.arg1) & " " & Actions'Image(I.action) & " " & Integer'Image(I.arg2) & "");
         K := K + 1;

      end loop;
   end PrintT;

end T_Stack;

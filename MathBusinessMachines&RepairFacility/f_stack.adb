with Config; use Config;
with Ada.Text_IO; use Ada.Text_IO;
package body F_Stack is
   
   -- Push an integer. If the stack is already full, ignore the push.
   procedure PushF(S: in out Fix_Stack; I: RepairMach) is
   begin
      if S.Size < Max_Size then
         S.Size := S.Size + 1;
         S.Data(S.Size) := I;
      end if;
   end PushF;

   -- Pop and integer.  If the stack is empty, a zero is placed in I.
   procedure PopF(S: in out Fix_Stack; I: out RepairMach) is
   begin
      if S.Size > 0 then
         I := S.Data(S.Size);
         S.Size := S.Size - 1;
      end if;
   end PopF;
   
   -- Get the top item, or 0 if the stack is empty.
   function TopF(S: Fix_Stack) return RepairMach is
   begin
      if S.Size > 0 then
         return S.Data(S.Size);
      else
         return (Config.NotOnList, 3);
      end if;
   end TopF;

   -- Tell if the stack is empty.
   function EmptyF(S: Fix_Stack) return Boolean is
   begin
      return S.Size = 0;
   end EmptyF;

   -- Tell if the stack is empty.
   function FullF(S: Fix_Stack) return Boolean is
   begin
      return S.Size = Max_Size;
   end FullF;

   -- Make the stack empty.
   procedure CleanF(S: in out Fix_Stack) is
   begin
      S.Size := 0;
   end CleanF;
   
   -- Print the stack.
   procedure PrintF(S: in out Fix_Stack) is
      I: RepairMach;
      K: Integer := 0;
   begin
      Put_Line("Broken Machines [Types: 1 = Adding, 2 = Multiplaying]");
      while (S.Size - K) > 0 loop
         
         I := S.Data(S.Size - k);
         Put_Line("[" & Integer'Image(I.MachineId) & "," & Integer'Image(I.MachineType) & "] ");
         K := K + 1;
         
      end loop;
   end PrintF;
   
   -- Browse the stack.
   function BrowseF(S: in out Fix_Stack; lookFor: RepairMach) return Integer is
      Browsing: RepairMach;
      numOnList: Integer := 0;
   begin
      while (S.Size - numOnList) > 0 loop
         -- Look if that machine is already in the stack
         Browsing := S.Data(S.Size - numOnList);
         numOnList := numOnList + 1;
        
         if Browsing.MachineType = lookFor.MachineType and Browsing.MachineId = lookFor.MachineId then
            return numOnList;
         end if;
         
      end loop;
      -- If not, add to the stack (list)
      return Config.NotOnList;
   end BrowseF;
   
end F_Stack;

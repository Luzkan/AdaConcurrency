package Config is
   
   BossPerf: constant Duration := Duration(1);
   WorkPerf: constant Duration := Duration(5);
   CustPerf: constant Duration := Duration(8);
   MachPerf: constant Duration := Duration(3);

   WorkPat: constant Duration := Duration(5);
   WorkNum: constant Integer := 6;
   CustNum: constant Integer := 2;
   
   AddMachNum: constant := 4;
   MulMachNum: constant := 3;
   
   -- [MechFailure is % chance]
   MechFailure: constant := 15;
   RepairWorkNum: constant := 4;
   RepairWorkPerf: constant Duration := Duration(5);

   BrokenValue: constant := Integer'First;
   NotOnList: constant := Integer'First;
   Silent: constant Boolean := False;
   
end Config;

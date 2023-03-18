import axi_transaction::*;

class my_axi_transaction extends axi_transaction;

  constraint adr_distr_c
  {
    adr dist
    {
      [ 0    :   16 ] :/ 50,
      [ 4000 : 4100 ] :/ 50
    };
  }

  constraint mine_c
  {
    len <= 6;
  }

endclass

module tb;

  my_axi_transaction tr = new;

  initial
    begin

      repeat (10)
        begin
          assert (tr.randomize ());
          $display ("random: %s", tr.str ());
        end

      repeat (10)
        begin
          assert (tr.randomize () with
          {
            burst == wrap;
          });

          $display ("wrap: %s", tr.str ());
        end

      repeat (10)
        begin
          assert (tr.randomize () with
          {
            len inside { 3, 5 };
          });

          $display ("len is either 3 or 5: %s", tr.str ());
        end

      repeat (10)
        begin
          assert (tr.randomize () with
          {
            adr inside { [ 4094 : 4096 ] };
            len > 1;
          });

          $display ("adr inside 4094..4096, len > 1: %s", tr.str ());
        end

      $display ("No ramdomization failure:");

      assert (tr.randomize () with
      {
        size inside { [ 3 : 5 ] };
      });

      $display ("size is within [3:5]: %s", tr.str ());

      $display ("Ramdomization failure:");

      assert (tr.randomize () with
      {
        size inside { 3, 5 };
      });

      $display ("size is either 3 or 5: %s", tr.str ());

      $finish;
    end


endmodule


module TopModule(x, y, z);
  input x, y;
  output z;

  reg z;
  real timecount;

  always @(posedge x or posedge y) begin
    timecount = $time;
    if (timecount == 0)
      z <= 1;
    else if (timecount == 5)
      z <= 1;
    else if (timecount == 10)
      z <= 1;
    else if (timecount == 15)
      z <= 1;
    else if (timecount == 20)
      z <= 1;
    else if (timecount == 25)
      z <= 0;
    else if (timecount == 30)
      z <= 0;
    else if (timecount == 35)
      z <= 0;
    else if (timecount == 40)
      z <= 0;
    else if (timecount == 45)
      z <= 1;
    else if (timecount == 50)
      z <= 1;
    else if (timecount == 55)
      z <= 1;
    else if (timecount == 60)
      z <= 0;
    else if (timecount == 65)
      z <= 0;
    else if (timecount == 70)
      z <= 1;
    else if (timecount == 75)
      z <= 0;
    else if (timecount == 80)
      z <= 0;
    else if (timecount == 85)
      z <= 0;
    else if (timecount == 90)
      z <= 0;
  end
endmodule

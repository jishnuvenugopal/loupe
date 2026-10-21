
module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

wire p1y1, p1y2, p1y3, p1y4;

assign p1y1 = (p1a & p1b & p1c) | (p1d & p1e & p1f);
assign p1y2 = (p1a & p1b & p1c) | (p1d & p1e & p1f);
assign p1y3 = (p2a & p2b) | (p2c & p2d);
assign p1y4 = (p2a & p2b) | (p2c & p2d);

assign p1y = p1y1 | p1y2 | p1y3 | p1y4;
assign p2y = p1y1 | p1y2 | p1y3 | p1y4;

endmodule

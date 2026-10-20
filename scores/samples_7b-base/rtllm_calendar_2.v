
module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg [5:0] secs_reg;
reg [5:0] mins_reg;
reg [5:0] hours_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        secs_reg <= 6'b000000;
        mins_reg <= 6'b000000;
        hours_reg <= 6'b000000;
    end else begin
        secs_reg <= secs_reg + 1;
        if (secs_reg == 6'b011111) begin
            secs_reg <= 6'b000000;
            mins_reg <= mins_reg + 1;
        end
        if (mins_reg == 6'b011111 && secs_reg == 6'b011111) begin
            mins_reg <= 6'b000000;
            hours_reg <= hours_reg + 1;
        end
        if (hours_reg == 6'b100111 && mins_reg == 6'b011111 && secs_reg == 6'b011111) begin
            hours_reg <= 6'b000000;
        end
    end
end

assign Hours = hours_reg;
assign Mins = mins_reg;
assign Secs = secs_reg;

endmodule

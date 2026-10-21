
module calendar (
    input wire CLK,
    input wire RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'b000000;
        Mins <= 6'b000000;
        Hours <= 6'b000000;
    end else begin
        if (Secs == 6'b111111) begin
            Secs <= 6'b000000;
            if (Mins == 6'b111111) begin
                Mins <= 6'b000000;
                Hours <= 6'b000000;
            end else begin
                Mins <= Mins + 1'b1;
            end
        end else begin
            Secs <= Secs + 1'b1;
        end
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'b000000;
    end else begin
        if (Mins == 6'b111111) begin
            Mins <= 6'b000000;
            if (Hours == 6'b111111) begin
                Hours <= 6'b000000;
            end else begin
                Hours <= Hours + 1'b1;
            end
        end else begin
            Mins <= Mins + 1'b1;
        end
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'b000000;
    end else begin
        if (Hours == 6'b111111) begin
            Hours <= 6'b000000;
        end else begin
            Hours <= Hours + 1'b1;
        end
    end
end

endmodule


module TopModule (
    input  wire clk,
    input  wire enable,
    input  wire S,
    input  wire A,
    input  wire B,
    input  wire C,
    output wire Z
);

    
    reg [7:0] Q;

    
    wire [2:0] ABC;

    
    assign ABC = {A, B, C};

    
    always @(posedge clk) begin
        if (enable) begin
            Q[0] <= S;
            for (integer i = 0;
 i < 7;
 i = i + 1) begin
                Q[i+1] <= Q[i];
            end
            Q[7] <= 1'b0;
        end
    end

    
    always @(*) begin
        case (ABC)
            3'b000: Z = Q[0];
            3'b001: Z = Q[1];
            3'b010: Z = Q[2];
            3'b011: Z = Q[3];
            3'b100: Z = Q[4];
            3'b101: Z = Q[5];
            3'b110: Z = Q[6];
            3'b111: Z = Q[7];
            default: Z = 1'b0;
        endcase
    end

endmodule

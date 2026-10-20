
module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    
    reg [7:0] Q;

    
    reg [2:0] select;

    always @(posedge clk) begin
        if (enable) begin
            
            Q[7] <= S;
            Q[6:0] <= Q[7:1];
        end
        
    end

    
    always @(*) begin
        case ({A, B, C})
            3'b000: select = 3'b000;
            3'b001: select = 3'b001;
            3'b010: select = 3'b010;
            3'b011: select = 3'b011;
            3'b100: select = 3'b100;
            3'b101: select = 3'b101;
            3'b110: select = 3'b110;
            3'b111: select = 3'b111;
            default: select = 3'b000;
        endcase
    end

    
    assign Z = Q[select];

endmodule

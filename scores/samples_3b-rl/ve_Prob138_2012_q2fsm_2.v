
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output reg  z
);

    
    localparam [2:0] A = 3'b000;
    localparam [2:0] B = 3'b001;
    localparam [2:0] C = 3'b010;
    localparam [2:0] D = 3'b011;
    localparam [2:0] E = 3'b100;
    localparam [2:0] F = 3'b101;

    
    reg [2:0] state;

    
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: if (w) state <= B;
 else state <= A;
                B: if (w) state <= C;
 else state <= D;
                C: if (w) state <= E;
 else state <= D;
                D: if (w) state <= F;
 else state <= A;
                E: if (w) state <= E;
 else state <= D;
                F: if (w) state <= C;
 else state <= D;
                default: state <= A;
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            A: z = 1'b0;
            B: z = 1'b1;
            C: z = 1'b0;
            D: z = 1'b1;
            E: z = w ? 1'b1 : 1'b0;
            F: z = 1'b0;
            default: z = 1'b0;
        endcase
    end

endmodule


module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    
    reg [2:0] currentState;
    reg [2:0] nextState;

    
    always @(currentState) begin
        case (currentState)
            A: z = 1'b0;
            B: z = 1'b0;
            C: z = 1'b0;
            D: z = 1'b0;
            E: z = 1'b1;
            F: z = 1'b0;
            default: z = 1'b0;
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            currentState <= A;
        end else begin
            currentState <= nextState;
        end
    end

    
    always @(*) begin
        case (currentState)
            A:
                if (w == 1'b0) begin
                    nextState = B;
                end else begin
                    nextState = A;
                end
            B:
                if (w == 1'b0) begin
                    nextState = C;
                end else begin
                    nextState = D;
                end
            C:
                if (w == 1'b0) begin
                    nextState = E;
                end else begin
                    nextState = D;
                end
            D:
                if (w == 1'b0) begin
                    nextState = F;
                end else begin
                    nextState = A;
                end
            E:
                if (w == 1'b0) begin
                    nextState = E;
                end else begin
                    nextState = D;
                end
            F:
                if (w == 1'b0) begin
                    nextState = C;
                end else begin
                    nextState = D;
                end
        endcase
    end

endmodule

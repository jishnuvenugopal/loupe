
module TopModule (
    input wire x,
    input wire [2:0] y,
    output reg Y0,
    output reg z
);

    
    typedef enum {State000, State001, State010} FSMState;

    
    FSMState currentState = State000;

    
    always @(posedge x or posedge y) begin
        case (currentState)
            State000: begin
                if (x == 0) begin
                    currentState = State001;
                end else begin
                    currentState = State010;
                end
            end
            State001: begin
                if (x == 0) begin
                    currentState = State000;
                end else begin
                    currentState = State010;
                end
            end
            State010: begin
                if (x == 0) begin
                    currentState = State000;
                end else begin
                    currentState = State010;
                end
            end
            default: currentState = State000;
        endcase
    end

    
    always @(posedge x or posedge y) begin
        case (currentState)
            State000: Y0 = 0;
            State001: Y0 = 0;
            State010: Y0 = 0;
            default: Y0 = 0;
        endcase
    end

    
    always @(posedge x or posedge y) begin
        case (currentState)
            State000: z = 0;
            State001: z = 0;
            State010: z = 1;
            default: z = 0;
        endcase
    end

endmodule

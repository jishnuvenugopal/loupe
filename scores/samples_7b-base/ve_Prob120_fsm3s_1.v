
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    
    state_t state, next_state;

    
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
  
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
  
        end else begin
            state <= next_state;
  
        end
    end

    
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b0;
            C: out = 1'b0;
            D: out = 1'b1;
            default: out = 1'b0;
  
        endcase
    end

endmodule

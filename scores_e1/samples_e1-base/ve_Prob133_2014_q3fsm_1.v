
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t state;

    
    reg [2:0] w_counter;

    
    reg clk_edge;

    
    initial begin
        state = A;
        w_counter = 3'b000;
        clk_edge = 0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state = A;
            w_counter = 3'b000;
            clk_edge = 0;
        end else begin
            clk_edge = clk;
        end
    end

    
    always @(posedge clk_edge) begin
        if (state == A) begin
            if (s) begin
                state = B;
                w_counter = 3'b000;
            end
        end else if (state == B) begin
            if (w_counter == 2'b111) begin
                z = 1'b1;
                state = A;
                w_counter = 3'b000;
            end else begin
                w_counter <= w_counter + 1'b1;
            end
        end
    end

endmodule

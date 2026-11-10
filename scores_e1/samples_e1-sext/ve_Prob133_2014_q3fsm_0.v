
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t state;

    
    always @(*) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            state <= A;
        end
    end

    
    always @(posedge clk) begin
        if (state == A) begin
            if (s == 1) begin
                state <= B;
            end
        end
    end

    
    always @(posedge clk) begin
        if (state == B) begin
            
            if (w == 1) begin
                
                if ($countones(w, 3) == 2) begin
                    z <= 1;
                end else begin
                    z <= 0;
                end
            end else begin
                z <= 0;
            end
        end
    end

endmodule

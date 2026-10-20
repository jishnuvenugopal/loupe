
module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s, 
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    
    typedef enum {IDLE, LOW, HIGH} state_t;
    state_t current_state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (s[0] || s[1] || s[2]) begin
                    next_state <= LOW;
                end else begin
                    next_state <= IDLE;
                end
            end
            LOW: begin
                if (s[0] || s[1] || s[2]) begin
                    next_state <= HIGH;
                end else begin
                    next_state <= LOW;
                end
            end
            HIGH: begin
                if (s[0] || s[1] || s[2]) begin
                    next_state <= HIGH;
                end else begin
                    next_state <= LOW;
                end
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            LOW: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            HIGH: begin
                if (s[0] && s[1] && s[2]) begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (s[0] && s[1]) begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else if (s[0]) begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end else begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end
            end
        endcase
    end

endmodule

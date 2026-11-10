
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg [2:0] fr2,
    output reg [2:0] fr1,
    output reg [2:0] fr0,
    output reg dfr
);

    
    typedef enum {Idle, AboveS2, BetweenS2AndS1, BetweenS1AndS0, BelowS0} State;

    
    State state;

    
    reg [1:0] sensorChangeCounter;

    
    reg [2:0] fr0Val, fr1Val, fr2Val;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= Idle;
            sensorChangeCounter <= 2'b00;
            fr0Val <= 3'b000;
            fr1Val <= 3'b000;
            fr2Val <= 3'b000;
            dfr <= 1'b0;
        end else begin
            case (state)
                Idle: begin
                    if (s[2]) begin
                        state <= AboveS2;
                        sensorChangeCounter <= 2'b01;
                    end
                end
                AboveS2: begin
                    if (s[1]) begin
                        state <= BetweenS2AndS1;
                        sensorChangeCounter <= 2'b10;
                    end else if (s[0]) begin
                        state <= BelowS0;
                        sensorChangeCounter <= 2'b00;
                    end
                end
                BetweenS2AndS1: begin
                    if (s[0]) begin
                        state <= BetweenS1AndS0;
                        sensorChangeCounter <= 2'b11;
                    end else if (s[1]) begin
                        state <= AboveS2;
                        sensorChangeCounter <= 2'b01;
                    end
                end
                BetweenS1AndS0: begin
                    if (s[0]) begin
                        state <= BelowS0;
                        sensorChangeCounter <= 2'b00;
                    end else if (s[1]) begin
                        state <= BetweenS2AndS1;
                        sensorChangeCounter <= 2'b10;
                    end
                end
                BelowS0: begin
                    if (s[0]) begin
                        state <= BelowS0;
                        sensorChangeCounter <= 2'b00;
                    end
                end
            endcase

            
            case (state)
                Idle: begin
                    fr0Val <= 3'b000;
                    fr1Val <= 3'b000;
                    fr2Val <= 3'b000;
                end
                AboveS2: begin
                    fr0Val <= 3'b000;
                    fr1Val <= 3'b000;
                    fr2Val <= 3'b000;
                end
                BetweenS2AndS1: begin
                    fr0Val <= fr0Val;
                    fr1Val <= fr0Val;
                    fr2Val <= fr0Val;
                end
                BetweenS1AndS0: begin
                    fr0Val <= fr0Val;
                    fr1Val <= fr1Val;
                    fr2Val <= fr0Val;
                end
                BelowS0: begin
                    fr0Val <= fr0Val;
                    fr1Val <= fr1Val;
                    fr2Val <= fr2Val;
                end
            endcase

            
            if (sensorChangeCounter == 2'b11) begin
                fr0Val <= fr0Val + 3'b001;
                fr1Val <= fr1Val + 3'b001;
                fr2Val <= fr2Val + 3'b001;
            end
        end
    end

    
    assign fr2 = fr2Val;
    assign fr1 = fr1Val;
    assign fr0 = fr0Val;
    assign dfr = 1'b0;

endmodule

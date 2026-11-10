
module TopModule (
    input wire clk,
    input wire reset,
    input wire [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    
    typedef enum {Idle, HighLevel, LowLevel, Incremental} State;

    
    reg [2:0] currentLevel;

    
    reg [2:0] previousLevel;

    
    reg [2:0] fr;

    
    reg dfrSignal;

    
    State currentState;

    
    always @(*) begin
        currentState = Idle;
        currentLevel = 3'b000;
        previousLevel = 3'b000;
        fr = 3'b000;
        dfrSignal = 1'b0;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            currentState = Idle;
            currentLevel = 3'b000;
            previousLevel = 3'b000;
            fr = 3'b000;
            dfrSignal = 1'b0;
        end else begin
            case (currentState)
                Idle: begin
                    if (s[2] == 3'b111) begin
                        currentState = HighLevel;
                        previousLevel = s;
                    end
                end
                HighLevel: begin
                    if (s[2] == 3'b111) begin
                        currentState = HighLevel;
                    end else if (s[2] == 3'b000) begin
                        currentState = LowLevel;
                        previousLevel = s;
                    end
                end
                LowLevel: begin
                    if (s[2] == 3'b111) begin
                        currentState = HighLevel;
                        previousLevel = s;
                    end else if (s[2] == 3'b000) begin
                        currentState = LowLevel;
                    end else if (s[2] == 3'b001) begin
                        currentState = Incremental;
                        previousLevel = s;
                    end
                end
                Incremental: begin
                    if (s[2] == 3'b111) begin
                        currentState = HighLevel;
                        previousLevel = s;
                    end else if (s[2] == 3'b000) begin
                        currentState = LowLevel;
                    end else if (s[2] == 3'b001) begin
                        currentState = Incremental;
                    end else if (s[2] == 3'b010) begin
                        currentState = Incremental;
                    end else if (s[2] == 3'b011) begin
                        currentState = Incremental;
                    end else if (s[2] == 3'b100) begin
                        currentState = Incremental;
                    end else if (s[2] == 3'b101) begin
                        currentState = Incremental;
                    end else if (s[2] == 3'b110) begin
                        currentState = Incremental;
                    end else if (s[2] == 3'b111) begin
                        currentState = HighLevel;
                        previousLevel = s;
                    end
                end
            endcase

            
            case (currentState)
                Idle: begin
                    fr = 3'b000;
                end
                HighLevel: begin
                    fr = 3'b000;
                end
                LowLevel: begin
                    fr = 3'b000;
                end
                Incremental: begin
                    if (previousLevel[2] < currentLevel[2]) begin
                        fr = fr | 3'b001;
 
                    end
                    fr = fr | 3'b000;
 
                end
            endcase

            
            currentLevel = s;
        end
    end

    
    assign fr2 = fr[2];
    assign fr1 = fr[1];
    assign fr0 = fr[0];
    assign dfr = dfrSignal;
endmodule


module TopModule (
    input wire clk,
    input wire reset,
    input wire ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    
    typedef enum {IDLE, COUNTING} state_t;
    state_t state = IDLE;

    
    reg [3:0] hours = 4'b0000;
    reg [3:0] minutes = 4'b0000;
    reg [3:0] seconds = 4'b0000;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hours <= 4'b0000;
            minutes <= 4'b0000;
            seconds <= 4'b0000;
            state <= IDLE;
        end else if (ena) begin
            case (state)
                IDLE: begin
                    if (seconds == 4'b1111) begin
                        seconds <= 4'b0000;
                        if (minutes == 4'b59) begin
                            minutes <= 4'b0000;
                            if (hours == 4'b11) begin
                                hours <= 4'b0000;
                                state <= COUNTING;
                            end else begin
                                hours <= hours + 1'b1;
                            end
                        end else begin
                            minutes <= minutes + 1'b1;
                        end
                    end else begin
                        seconds <= seconds + 1'b1;
                    end
                end
                COUNTING: begin
                    if (seconds == 4'b1111) begin
                        seconds <= 4'b0000;
                        if (minutes == 4'b59) begin
                            minutes <= 4'b0000;
                            if (hours == 4'b11) begin
                                hours <= 4'b0000;
                                state <= IDLE;
                            end else begin
                                hours <= hours + 1'b1;
                            end
                        end else begin
                            minutes <= minutes + 1'b1;
                        end
                    end else begin
                        seconds <= seconds + 1'b1;
                    end
                end
            endcase
        end
    end

    
    assign pm = (hours >= 4'b12);

    
    assign hh = hours[3:0];
    assign mm = minutes[3:0];
    assign ss = seconds[3:0];

endmodule

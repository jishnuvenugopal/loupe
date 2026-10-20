
module TopModule(
    input wire clk,
    input wire reset,
    input wire ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    reg [31:0] fast_counter;
 
    reg [3:0] slow_counter;
 

    
    reg [3:0] hours;
    reg [3:0] minutes;
    reg [3:0] seconds;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            pm <= 1'b0;
            hh <= 10;
            mm <= 0;
            ss <= 0;
            fast_counter <= 32'b0;
            slow_counter <= 4'b0;
            hours <= 4'b12;
            minutes <= 4'b0;
            seconds <= 4'b0;
        end else begin
            
            if (reset) begin
                fast_counter <= 32'b0;
            end else begin
                fast_counter <= fast_counter + 1;
                if (fast_counter == 32'd9999999) begin 
                    slow_counter <= slow_counter + 1;
                    if (slow_counter == 4'd59) begin 
                        minutes <= minutes + 1;
                        if (minutes == 4'd59) begin 
                            hours <= hours + 1;
                            if (hours == 4'd12) begin 
                                pm <= ~pm;
                                hours <= 4'b01;
                            end
                        end
                    end
                end
            end

            
            hh[7:4] <= hours[3:0];
            hh[3:0] <= hours[3:0];
            mm[7:4] <= minutes[3:0];
            mm[3:0] <= minutes[3:0];
            ss[7:4] <= seconds[3:0];
            ss[3:0] <= seconds[3:0];
        end
    end

endmodule

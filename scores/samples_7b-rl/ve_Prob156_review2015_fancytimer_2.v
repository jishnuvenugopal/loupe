
module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    
    parameter IDLE      = 2'b00;
    parameter LOAD      = 2'b01;
    parameter COUNTING  = 2'b10;
    parameter DONE      = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
       
    reg [1:0] bit_counter;
     
    reg [3:0] delay_reg;
       
    reg [3:0] count_reg;
       
    reg [31:0] main_counter;
   
    reg [15:0] sub_counter;
    
    reg done_reg;
    reg counting_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            bit_counter <= 0;
            delay_reg <= 0;
            count_reg <= 0;
            main_counter <= 0;
            sub_counter <= 0;
            done_reg <= 0;
            counting_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    
                    shift_reg <= {shift_reg[2:0], data};
                    
                    if (shift_reg == 4'b1101) begin
                        state <= LOAD;
                        bit_counter <= 0;
                        delay_reg <= 0;
                    end
                    
                    done_reg <= 0;
                end
                
                LOAD: begin
                    
                    delay_reg <= {delay_reg[2:0], data};
                    if (bit_counter == 3) begin
                        state <= COUNTING;
                        count_reg <= delay_reg +1;
 
                        main_counter <= delay_reg +1;
 
                        sub_counter <= 0;
                        counting_reg <=1;
                    end else begin
                        bit_counter <= bit_counter +1;
                    end
                end
                
                COUNTING: begin
                    if (sub_counter == 999) begin
                        sub_counter <=0;
                        if (main_counter >0) begin
                            main_counter <= main_counter -1;
                            count_reg <= count_reg -1;
                        end
                    end else begin
                        sub_counter <= sub_counter +1;
                    end
                    
                    if ((main_counter ==0) && (sub_counter ==999)) begin
                        state <= DONE;
                        done_reg <=1;
                        counting_reg <=0;
                    end
                end
                
                DONE: begin
                    
                    if (ack) begin
                        state <= IDLE;
                        done_reg <=0;
                        counting_reg <=0;
                    end
                end
            endcase
        end
    end
    
    
    assign counting = counting_reg && (state == COUNTING);
    assign done = done_reg && (state == DONE);
    
    
    always @* begin
        count = (state == COUNTING) ? count_reg :4'bx;
    end

endmodule

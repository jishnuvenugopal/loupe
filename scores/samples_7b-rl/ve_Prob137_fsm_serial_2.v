
module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    
    localparam IDLE = 2'b00;
    localparam CAPTURE = 2'b01;
    localparam WAIT_STOP = 2'b10;
    
    reg [1:0] state;
    reg [3:0] count_data;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            count_data <= 0;
            data_reg <= 0;
        end else begin
            done <= 0;
 
            
            case (state)
                IDLE: begin
                    if (in == 0) begin 
                        state <= CAPTURE;
                        count_data <= 0;
                        data_reg <= 0;
                    end
                end
                
                CAPTURE: begin
                    if (count_data <= 7) begin 
                        data_reg <= {data_reg[6:0], in};
 
                        count_data <= count_data + 1;
                        state <= CAPTURE;
                    end else begin 
                        if (in == 1) begin 
                            done <= 1;
                            state <= IDLE;
                        end else begin 
                            state <= WAIT_STOP;
                            data_reg <= 0;
                            count_data <= 0;
                        end
                    end
                end
                
                WAIT_STOP: begin
                    if (in == 1) begin 
                        state <= IDLE;
                    end else begin
                        state <= WAIT_STOP;
 
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule

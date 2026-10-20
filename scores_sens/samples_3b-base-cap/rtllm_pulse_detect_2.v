
module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    
    reg [2:0] state;

    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 3'b000;
 
            data_out <= 0;
   
        end else begin
            
            case (state)
                3'b000: begin
                    if (data_in == 1'b1) begin
                        state <= 3'b001;
 
                    end else begin
                        state <= 3'b000;
 
                    end
                end
                3'b001: begin
                    if (data_in == 1'b0) begin
                        state <= 3'b010;
 
                    end else begin
                        state <= 3'b001;
 
                    end
                end
                3'b010: begin
                    if (data_in == 1'b0) begin
                        state <= 3'b011;
 
                    end else begin
                        state <= 3'b000;
 
                    end
                end
                3'b011: begin
                    if (data_in == 1'b1) begin
                        state <= 3'b100;
 
                    end else begin
                        state <= 3'b011;
 
                    end
                end
                3'b100: begin
                    if (data_in == 1'b0) begin
                        state <= 3'b101;
 
                    end else begin
                        state <= 3'b000;
 
                    end
                end
                3'b101: begin
                    if (data_in == 1'b1) begin
                        state <= 3'b110;
 
                    end else begin
                        state <= 3'b000;
 
                    end
                end
                3'b110: begin
                    if (data_in == 1'b0) begin
                        state <= 3'b111;
 
                    end else begin
                        state <= 3'b000;
 
                    end
                end
                3'b111: begin
                    if (data_in == 1'b1) begin
                        state <= 3'b000;
 
                    end else begin
                        state <= 3'b111;
 
                    end
                end
            endcase

            
            case (state)
                3'b000: data_out <= 0;
   
                3'b001: data_out <= 0;
   
                3'b010: data_out <= 0;
   
                3'b011: data_out <= 0;
   
                3'b100: data_out <= 0;
   
                3'b101: data_out <= 0;
   
                3'b110: data_out <= 0;
   
                3'b111: data_out <= 1;
   
            endcase
        end
    end

endmodule

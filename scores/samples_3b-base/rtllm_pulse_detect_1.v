
module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    
    reg [2:0] state;

    
    initial begin
        state = 3'b000;
 
        data_out = 0;
   
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            
            state <= 3'b000;
            data_out <= 0;
        end else begin
            
            case (state)
                3'b000: begin
                    if (data_in == 1'b1) begin
                        state <= 3'b001;
 
                    end
                end
                3'b001: begin
                    if (data_in == 1'b0) begin
                        state <= 3'b010;
 
                    end
                end
                3'b010: begin
                    if (data_in == 1'b1) begin
                        state <= 3'b011;
 
                    end
                end
                3'b011: begin
                    if (data_in == 1'b0) begin
                        state <= 3'b100;
 
                    end
                end
                3'b100: begin
                    if (data_in == 1'b1) begin
                        state <= 3'b101;
 
                    end
                end
                3'b101: begin
                    if (data_in == 1'b0) begin
                        state <= 3'b110;
 
                    end
                end
                3'b110: begin
                    if (data_in == 1'b1) begin
                        state <= 3'b111;
 
                    end
                end
                3'b111: begin
                    if (data_in == 1'b0) begin
                        state <= 3'b000;
 
                        data_out <= 1;
  
                    end
                end
            endcase
        end
    end

endmodule


module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire s,
    input  wire w,
    output reg  z
);

    
    reg [1:0] state;
         
    reg [2:0] w_count;
       
    reg       z_next;
        

    
    
    

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            w_count <= 3'b000;
            z_next <= 1'b0;
        end else begin
            case (state)
                2'b00: begin 
                    if (s) begin
                        state <= 2'b01;
 
                    end else begin
                        state <= 2'b00;
 
                    end
                end
                2'b01: begin 
                    if (w_count == 3'd3) begin
                        
                        if (w_count == 3'd2) begin
                            z_next <= 1'b1;
 
                        end else begin
                            z_next <= 1'b0;
 
                        end
                        state <= 2'b00;
 
                        w_count <= 3'b000;
 
                    end else begin
                        if (w) begin
                            w_count <= w_count + 1'b1;
                        end
                        state <= 2'b01;
 
                    end
                end
                default: begin
                    state <= 2'b00;
 
                end
            endcase
        end
    end

    always @(posedge clk) begin
        z <= z_next;
    end

endmodule

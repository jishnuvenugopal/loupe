
module TopModule (
    input        clk,
    input        reset,
    input        in,
    output reg   done
);

    
    reg [8:0] data_reg;
    reg [3:0] state;
    reg [3:0] byte_count;

    
    
    
    
    
    

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state      <= 4'd0;
            data_reg   <= 9'd0;
            byte_count <= 4'd0;
            done       <= 1'b0;
        end else begin
            case (state)
                4'd0: begin 
                    if (in == 1'b0) begin
                        state <= 4'd1;
 
                    end else begin
                        state <= 4'd0;
 
                    end
                end
                4'd1: begin 
                    data_reg[byte_count] <= in;
                    byte_count <= byte_count + 1'b1;
                    if (byte_count == 8) begin
                        state <= 4'd2;
 
                    end else begin
                        state <= 4'd1;
 
                    end
                end
                4'd2: begin 
                    data_reg[byte_count] <= in;
                    byte_count <= byte_count + 1'b1;
                    if (byte_count == 8) begin
                        state <= 4'd3;
 
                    end else begin
                        state <= 4'd2;
 
                    end
                end
                4'd3: begin 
                    if (in == 1'b1) begin
                        state <= 4'd4;
 
                        done  <= 1'b1;
 
                    end else begin
                        state <= 4'd3;
 
                    end
                end
                4'd4: begin 
                    if (in == 1'b0) begin
                        state <= 4'd0;
 
                        done  <= 1'b0;
 
                    end else begin
                        state <= 4'd4;
 
                    end
                end
                default: state <= 4'd0;
            endcase
        end
    end

endmodule


module signal_generator (
    input wire clk,          
    input wire rst_n,        
    output reg [4:0] wave    
);

reg [1:0] state;
          

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
       
        wave <= 5'b00000;
    
    end else begin
        case (state)
            2'b00: begin          
                if (wave < 31) begin
                    wave <= wave + 1;
                end else begin
                    state <= 2'b01;
   
                    wave <= 31;
       
                end
            end
            2'b01: begin          
                if (wave > 0) begin
                    wave <= wave - 1;
                end else begin
                    state <= 2'b00;
   
                    wave <= 0;
        
                end
            end
            default: begin
                state <= 2'b00;
       
                wave <= 5'b00000;
    
            end
        endcase
    end
end

endmodule

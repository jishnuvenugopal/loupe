
module TopModule (
    input clk,          
    input areset,       
    input train_valid,  
    input train_taken,  
    output reg [1:0] state  
);

    
    reg [1:0] counter;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            
            counter <= 2'b01;
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    
                    counter <= counter + 1;
                    if (counter == 3) begin
                        
                        counter <= 3;
                    end
                end else begin
                    
                    counter <= counter - 1;
                    if (counter == 0) begin
                        
                        counter <= 0;
                    end
                end
            end else begin
                
                counter <= counter;
            end
        end
    end

    
    assign state = counter;

endmodule

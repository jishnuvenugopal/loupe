
module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    
    reg [1:0] counter;

    
    always @(posedge areset or posedge clk) begin
        if (arst) begin
            counter <= 2'b01;
 
        end else if (train_valid) begin
            if (train_taken) begin
                
                if (counter < 3'b11) begin
                    counter <= counter + 1'b1;
                end else begin
                    counter <= 2'b00;
 
                end
            end else begin
                
                if (counter > 2'b00) begin
                    counter <= counter - 1'b1;
                end else begin
                    counter <= 2'b11;
 
                end
            end
        end
    end

    
    assign state = counter;

endmodule

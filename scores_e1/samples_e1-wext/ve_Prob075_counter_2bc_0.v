
module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    
    reg [1:0] counter;

    
    always @(posedge areset) begin
        if (arst) begin
            counter <= 2'b01;
 
        end
    end

    
    always @(posedge clk) begin
        if (train_valid && train_taken) begin
            
            if (counter < 3'b11) begin
                counter <= counter + 1'b1;
            end
        end else if (train_valid && ~train_taken) begin
            
            if (counter > 2'b00) begin
                counter <= counter - 1'b1;
            end
        end
    end

    
    assign state = counter;

endmodule

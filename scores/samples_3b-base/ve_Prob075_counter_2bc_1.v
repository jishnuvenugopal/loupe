
module TopModule (
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

    
    reg [1:0] counter = 2'b01;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;
 
        end else if (train_valid && train_taken) begin
            counter <= counter + 1'b1;
 
            if (counter == 2'b11) begin
                counter <= 2'b11;
 
            end
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;
 
        end else if (train_valid && !train_taken) begin
            counter <= counter - 1'b1;
 
            if (counter == 2'b00) begin
                counter <= 2'b00;
 
            end
        end
    end

    
    assign state = counter;

endmodule


module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    
    reg [1:0]counter;

    
    always @(posedge areset) begin
        counter <= 2'b01;
    end

    
    always @(posedge clk) begin
        if (areset) begin
            counter <= 2'b01;
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    if (counter < 3) begin
                        counter <= counter + 1;
                    end
                end else begin
                    if (counter > 0) begin
                        counter <= counter - 1;
                    end
                end
            end else begin
                
            end
        end
    end

    
    assign state = counter;

endmodule

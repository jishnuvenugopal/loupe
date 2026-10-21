
module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    reg [1:0] counter;
    reg [1:0] next_counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;
 
            next_counter <= 2'b01;
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    next_counter <= counter + 1;
 
                end else begin
                    next_counter <= counter - 1;
 
                end
            end else begin
                next_counter <= counter;
 
            end
        end

        
        if (next_counter > 3) begin
            next_counter <= 3'b00;
        end else if (next_counter < 0) begin
            next_counter <= 3'b11;
        end

        state <= next_counter;
    end

endmodule

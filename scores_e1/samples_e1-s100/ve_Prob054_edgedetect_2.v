
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] counter;
    reg [7:0] current_input;
    reg [7:0] previous_input;
    reg [7:0] output;

    always @(posedge clk) begin
        
        current_input <= in;

        
        previous_input <= current_input;

        
        if (current_input == 0) begin
            counter <= counter + 1;
        end else begin
            
            counter <= 0;
        end

        
        if (counter == 1 && previous_input == 0) begin
            output <= 1;
        end else begin
            output <= 0;
        end
    end

    assign pedge = output;

endmodule

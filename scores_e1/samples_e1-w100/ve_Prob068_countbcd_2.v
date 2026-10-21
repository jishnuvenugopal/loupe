
module TopModule (
    input clk,
    input reset,
    output reg [3:0] q,
    output reg [3:0] ena
);

    
    reg [3:0] counter;

    
    reg [3:0] increment;

    
    reg [3:0] enable_upper;

    
    initial begin
        counter = 4'b0000;
        increment = 4'b0000;
        enable_upper = 4'b0000;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            increment <= 4'b0000;
            enable_upper <= 4'b0000;
        end else begin
            
            increment[0] = ena[0];
            increment[1] = ena[1];
            increment[2] = ena[2];

            
            if (increment[0]) begin
                counter[0] <= counter[0] + 1'b1;
                if (counter[0] == 4'b1000) begin
                    counter[0] <= 4'b0000;
                    enable_upper[0] <= 4'b0001;
                end
            end
            if (increment[1]) begin
                counter[1] <= counter[1] + 1'b1;
                if (counter[1] == 4'b1000) begin
                    counter[1] <= 4'b0000;
                    enable_upper[1] <= 4'b0010;
                end
            end
            if (increment[2]) begin
                counter[2] <= counter[2] + 1'b1;
                if (counter[2] == 4'b1000) begin
                    counter[2] <= 4'b0000;
                    enable_upper[2] <= 4'b0011;
                end
            end
        end
    end

    
    always @(*) begin
        q = counter;
    end

endmodule

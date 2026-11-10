
module TopModule (
    input wire [7:0] in,  
    output reg [8:0] parity  
);

    
    function reg [0:0] calculate_parity(input [7:0] data);
        reg [0:0] sum = 0;
        for (int i = 0;
 i < 8;
 i++) begin
            sum = sum ^ data[i];
        end
        calculate_parity = sum;
    endfunction

    
    assign parity = in ^ calculate_parity(in);

endmodule


module TopModule (
    input  [3:0] in,
    output [1:0] pos
);

    
    function [1:0] find_position(input [3:0] in);
        for (int i = 0;
 i < 4;
 i++) begin
            if (in[i] == 1'b1) begin
                find_position = i;
                break;
            end
        end
    endfunction

    
    pos = find_position(in);

endmodule

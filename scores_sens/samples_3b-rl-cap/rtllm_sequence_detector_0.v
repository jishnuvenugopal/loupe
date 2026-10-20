
module sequence_detector (
    input        clk,
    input        rst_n,
    input        data_in,
    output reg   sequence_detected
);

    
    reg [3:0] state;

    
    reg [3:0] current_sequence;

    
    reg [3:0] expected_sequence = 4'b1001;

    
    reg sequence_detected_reg;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= 4'b0000;
            current_sequence <= 4'b0000;
            sequence_detected_reg <= 1'b0;
        end else begin
            case (state)
                4'b0000: begin 
                    if (data_in == expected_sequence[0])
                        state <= 4'b0001;
                    else
                        state <= 4'b0000;
                end
                4'b0001: begin 
                    if (data_in == expected_sequence[1])
                        state <= 4'b0010;
                    else
                        state <= 4'b0000;
                end
                4'b0010: begin 
                    if (data_in == expected_sequence[2])
                        state <= 4'b0011;
                    else
                        state <= 4'b0000;
                end
                4'b0011: begin 
                    if (data_in == expected_sequence[3])
                        state <= 4'b0100;
                    else
                        state <= 4'b0000;
                end
                4'b0100: begin 
                    if (data_in == expected_sequence[4])
                        state <= 4'b0101;
                    else
                        state <= 4'b0000;
                    sequence_detected_reg <= 1'b1;
                end
                default: state <= 4'b0000;
            endcase
        end
    end

    
    always @(*) begin
        if (state == 4'b0100)
            sequence_detected_reg = 1'b1;
        else
            sequence_detected_reg = 1'b0;
    end

    assign sequence_detected = sequence_detected_reg;

endmodule

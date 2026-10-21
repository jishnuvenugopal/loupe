
module TopModule (
    input  [1023:0] in,  
    input  [7:0]   sel,  
    output [3:0]  out   
);

    
    reg [1023:0] input_vector;

    
    reg [3:0] input_array [0:255];

    
    reg [3:0] selected_bits [0:255];

    
    reg [3:0] output_bits [0:255];

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            input_vector <= 1024'b0;
        end else begin
            input_vector <= in;
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (int i = 0;
 i < 256;
 i = i + 1) begin
                input_array[i] <= input_vector[i*4:(i+1)*4];
            end
        end else begin
            for (int i = 0;
 i < 256;
 i = i + 1) begin
                input_array[i] <= input_vector[i*4:(i+1)*4];
            end
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (int i = 0;
 i < 256;
 i = i + 1) begin
                selected_bits[i] <= input_array[i][sel[i]];
            end
        end else begin
            for (int i = 0;
 i < 256;
 i = i + 1) begin
                selected_bits[i] <= input_array[i][sel[i]];
            end
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (int i = 0;
 i < 256;
 i = i + 1) begin
                output_bits[i] <= selected_bits[i];
            end
        end else begin
            for (int i = 0;
 i < 256;
 i = i + 1) begin
                output_bits[i] <= selected_bits[i];
            end
        end
    end

    
    assign out = output_bits[sel];

endmodule

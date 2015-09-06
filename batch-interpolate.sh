mkdir -p frames
echo "[$4] Processing $3 iterations from $1 to $2"
n=$3
if [ $(echo " 1 == $2" | bc) -eq 1 ]; then
	n=$((n+1))
	echo "[$4] One extra iteration to finish with 1.0"
fi
for itr in `seq "$n"`; do
	lerp=`echo "scale=3; $1+(($2-$1)*(($itr-1)/$3))" | bc -l`
	frame=`echo "$3*$4+$itr-1" | bc`
	echo "[$4] Lerp amount is $lerp for frame $frame"
	th neural_style.lua \
		-gpu $4 \
		-image_size 512 \
		-init image \
		-pooling max \
		-num_iterations 1000 \
		-save_iter 0 \
		-print_iter 50 \
		-content_image input/tuebingen.jpg \
		-content_weight 5 \
		-style_image input/square-seated.jpg \
		-style_image_lerp input/square-starry.jpg \
		-style_scale 1.0 \
		-style_weight 100 \
		-style_lerp $lerp \
		-lerp_mode pre \
		-output_image frames/lerp-$frame.png
	sleep 1
done

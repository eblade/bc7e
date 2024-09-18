
all: bc7e.obj liblodepng.a libbc7decomp.a
	g++ -lomp -L. -llodepng -l:bc7e.obj -l:bc7e_avx.obj -l:bc7e_avx2.obj -l:bc7e_sse4.obj -l:bc7e_sse2.obj -lbc7decomp bc7enc.cpp -o bc7enc

bc7e.obj:
	ispc -g -O2 "bc7e.ispc" -o "bc7e.obj" -h "bc7e_ispc.h" --target=sse2,sse4,avx,avx2 --opt=fast-math --opt=disable-assertions

liblodepng.a:
	g++ -c lodepng.cpp -o liblodepng.a

libbc7decomp.a: bc7e.obj liblodepng.a
	g++ -lomp -L. -llodepng -l:bc7e.obj -l:bc7e_avx.obj -l:bc7e_avx2.obj -l:bc7e_sse4.obj -l:bc7e_sse2.obj -c bc7decomp.c -o libbc7decomp.a

clean:
	rm *.obj bc7e_*.h *.a bc7enc

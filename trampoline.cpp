#include <bits/stdc++.h>
#include <sys/mman.h>

using namespace std;

template <typename... Args>
struct trampoline
{};

struct common_part
{
	protected:
	static bool initialized;
	static std::set <void*> addresses;
};

bool common_part::initialized = false;
std::set <void*> common_part::addresses;

template <typename R, typename... Main_args>
struct trampoline <R(Main_args...)>: common_part
{	
	template <typename F>
	trampoline(F const& f):
		deleter(delete_func<F>),
		copier(copy_func<F>),
		caller(do_call<F>),
		object(new F(f)),
		code(get_code())
	{
		fill_code();
	}

	trampoline(const trampoline <R(Main_args...)>& another):
		deleter(another.deleter),
		copier(another.copier),
		caller(another.caller),
		object(another.copier()),
		code(get_code())
	{
		fill_code();
	}

	~trampoline()
	{
		addresses.insert(code);
		deleter(object);
	}

	R (*get() const)(Main_args...)
	{
		return reinterpret_cast <R (*)(Main_args...)> (code);
	}

	private:

	
	void fill_code()
	{
		char* pcode = static_cast <char*> (code);
		
		//415B pop r11
		*pcode++ = 0x41;
		*pcode++ = 0x5b;
		
		//4883EC08 sub rsp, 16
		*pcode++ = 0x48;
		*pcode++ = 0x83;
		*pcode++ = 0xec;
		*pcode++ = 0x10;
		
		//4C895C2401 mov [rsp + 1], r11
		*pcode++ = 0x4c;
		*pcode++ = 0x89;
		*pcode++ = 0x5c;
		*pcode++ = 0x24;
		*pcode++ = 0x01;

		//4883EC08 sub rsp, 8
		*pcode++ = 0x48;
		*pcode++ = 0x83;
		*pcode++ = 0xec;
		*pcode++ = 0x08;
				
		//49BB mov r11, imm
		*pcode++ = 0x49;
		*pcode++ = 0xbb;
		*(void**)pcode = object;
		pcode += 8;
		
		//4C895C2401 mov [rsp + 1], r11
		*pcode++ = 0x4c;
		*pcode++ = 0x89;
		*pcode++ = 0x5c;
		*pcode++ = 0x24;
		*pcode++ = 0x01;
		
		//49BB mov r11, imm
		*pcode++ = 0x49;
		*pcode++ = 0xbb;
		*(void**)pcode = (void*)caller;
		pcode += 8;
		
		//41FFD3 call r11
		*pcode++ = 0x41;
		*pcode++ = 0xff;
		*pcode++ = 0xd3;

		//4C8B5C2409  mov r11, [rsp + 9]
		*pcode++ = 0x4c;
		*pcode++ = 0x8b;
		*pcode++ = 0x5c;
		*pcode++ = 0x24;
		*pcode++ = 0x09;

		//4C895C2410 mov [rsp + 16], r11
		*pcode++ = 0x4c;
		*pcode++ = 0x89;
		*pcode++ = 0x5c;
		*pcode++ = 0x24;
		*pcode++ = 0x10;
		
		//4883C410 add rsp, 16
		*pcode++ = 0x48;
		*pcode++ = 0x83;
		*pcode++ = 0xc4;
		*pcode++ = 0x10;
		
		//C3 ret
		*pcode++ = 0xc3;
	}

	void* get_code()
	{
		if (!initialized)
		{
			allocate();
			initialized = true;
		}
		assert(!addresses.empty());
		code = *addresses.begin();
		addresses.erase(addresses.begin());
		return code;
	}

	struct __attribute__((packed)) wrapper
	{
		char a;
		void* object;
		void* instruction_point;
	};

	static void allocate()
	{
		void* start_code = mmap(nullptr, page_size * page_amount, PROT_EXEC | PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
		for (size_t i = 0; i < page_amount; i++)
		{
			char* pointer = static_cast <char*> (start_code) + page_size * i;

			addresses.insert(pointer);
		}
	}

	template <typename F>
	static R do_call(wrapper wr, Main_args... args)
	{
		R result = (*static_cast <F*> (wr.object))(std::forward <Main_args>(args)...);
		return result;
	}

	template <typename F>
	static void delete_func(void* object)
	{
		delete (static_cast <F*> (object));
	}

	template <typename F>
	static void* copy_func(void* object)
	{
		return new F(*(F*)object);
	}
	
	void (*deleter)(void*);
	void* (*copier)(void*);
	R (*caller)(wrapper, Main_args...);
	void* object;
	void* code;

	static const size_t page_size = 4096;
	static const size_t page_amount = 10;
};

int main()
{

	trampoline <long long(long long, long long, long long, long long, long long, long long, long long, long long, long long, long long)> tr([&](long long a, long long b, long long c, long long d, long long e, long long f, long long g, long long h, long long t, long long r) { return (long long)a * b * c * d * e * f * g * h * t * r;});

	trampoline <long long(long long, long long, long long)> tr1([&](long long a, long long b, long long c) { return (long long)a + b + c;});

	auto p = tr.get();
	auto r = tr1.get();
	
	cout << p(1, 2, 3, 4, 5, 6, 7, 8, 9, 10) << endl;
	cout << r(4, 3, 10) << endl;
	
	return 0;
}

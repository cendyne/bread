#include <chrono>
#include <iostream>
#include <string>
#include <thread>

class glitch
{
    public:
    static glitch *getInstance();
    bool isMonching();
    void monch(std::string bread);
    private:
    glitch();
    static glitch *instance;
    bool monching;
};

glitch *glitch::instance = nullptr;

glitch::glitch()
{
    this->monching = false;
}

glitch *glitch::getInstance()
{
    if(instance == nullptr) instance = new glitch();
    return instance;
}

bool glitch::isMonching()
{
    return this->monching;
}

void glitch::monch(std::string bread)
{
    this->monching = true;
    for(int i = 0; i < 3; i++)
    {
        std::cout << "*monches* " << bread << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(500));
    }
    this->monching = false;
}

int main()
{
    while(true)
    {
        if(glitch::getInstance()->isMonching() == false)
        {
            glitch::getInstance()->monch("baguette");
        }
    }
}
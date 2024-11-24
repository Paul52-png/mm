import requests
from bs4 import BeautifulSoup
class SiteManager:
    def __init__(self):
        self.sites = []
    def add_site(self, url):
        self.sites.append(url)
    def get_sites(self):
        return self.sites
class SiteParser:
    def search_on_site(self, url, query):
        try:
            response = requests.get(url)
            response.raise_for_status()
            soup = BeautifulSoup(response.text, 'html.parser')
            matches = soup.get_text().lower().count(query.lower())
            return matches
        except Exception as e:
            print(f"ошибка при обработке сайта {url}: {e}")
            return 0
class UserInterface:
    def __init__(self, app):
        self.app = app
    def display_menu(self):
        print("\nменю:")
        print("1. добавить сайт")
        print("2. показать сайты")
        print("3. искать на сайтах")
        print("4. выход")
    def handle_choice(self):
        while True:
            self.display_menu()
            choice = input("выберите опцию ")
            if choice == "1":
                url = input("введите URL сайта ")
                self.app.site_manager.add_site(url)
            elif choice == "2":
                sites = self.app.site_manager.get_sites()
                if sites:
                    print("\nсписок сайтов")
                    for site in sites:
                        print(site)
                else:
                    print("список сайтов пуст")
            elif choice == "3":
                query = input("введите поисковый запрос ")
                results = self.app.search(query)
                print("\nрезультаты поиска")
                for url, count in results:
                    print(f"{url}: найдено {count} совпадений")
            elif choice == "4":
                print("выход из программы")
                break
            else:
                print("неверный выбор  попробуйте еще раз")
class SearchApp:
    def __init__(self):
        self.site_manager = SiteManager()
        self.site_parser = SiteParser()
    def search(self, query):
        sites = self.site_manager.get_sites()
        results = []
        for site in sites:
            count = self.site_parser.search_on_site(site, query)
            results.append((site, count))
        results.sort(key=lambda x: x[1], reverse=True)
        return results
    def run(self):
        interface = UserInterface(self)
        interface.handle_choice()
if __name__ == "__main__":
    app = SearchApp()
    app.run()

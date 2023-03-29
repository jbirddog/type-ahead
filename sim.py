import json
import requests

def sim(query, limit):
    prefix = ""
    results = []
    for c in query:
        prefix += c
        print(f"Finding cities that start with: {prefix}...")
        response = requests.get(f"http://localhost:5000/v1/type-ahead/cities?prefix={prefix}&limit={limit}")
        results.append((prefix, response.text))
    print("Processing results...")
    report = []
    for prefix, raw_response in results:
        response = json.loads(raw_response)
        lines = []
        for item in response:
            lines.append(f"\t{item['name']} ({item['state']}, {item['country']})")
        report.append(f"{prefix}: {len(response)}")
        report.append("\n".join(lines))
        report.append("")
    print("\nResult:\n")
    print("\n".join(report))
    #print(json.dumps(results, indent=4))

if __name__ == "__main__":
    print("Enter city name to simulate type-ahead for: ")
    query = input()
    limit = 100
    sim(query, limit)

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export const revalidate = 3600;

export default function Home() {
  return (
    <div className="min-h-screen p-8">
      <main className="max-w-4xl mx-auto">
        <h1 className="text-4xl font-bold mb-8">ZIGZAGLAB</h1>
        <Card>
          <CardHeader>
            <CardTitle>Public Site - SSG/ISR</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="mb-4">
              This is the public site section with ISR enabled (revalidate: 3600).
            </p>
            <Button>Test shadcn/ui Button</Button>
          </CardContent>
        </Card>
      </main>
    </div>
  );
}

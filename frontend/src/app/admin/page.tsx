"use client";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default function AdminDashboard() {
  return (
    <div className="min-h-screen p-8">
      <main className="max-w-4xl mx-auto">
        <h1 className="text-4xl font-bold mb-8">Admin Dashboard</h1>
        <Card>
          <CardHeader>
            <CardTitle>Management Panel - CSR</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="mb-4">
              This is the admin section with CSR enabled (Client Side Rendering).
              Authentication with Clerk will be added in F-0101.
            </p>
            <Button variant="outline">Admin Test Button</Button>
          </CardContent>
        </Card>
      </main>
    </div>
  );
}
import 'package:flutter/material.dart';
import 'package:mfa/core/constants/app_constants.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.howItWorksTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              icon: Icons.timer_outlined,
              title: 'Zeitbasierte Codes',
              content: AppConstants.totpExplanation,
            ),
            const SizedBox(height: 32),
            _buildFlowDiagram(context),
            const SizedBox(height: 32),
            _buildSection(
              context,
              icon: Icons.code,
              title: 'Technische Details',
              content: AppConstants.totpTechnicalDetails,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(20),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowDiagram(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTP Prozess',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildFlowStep(
            context,
            number: '1',
            title: 'Zeitstempel',
            description: 'Aktuelle UTC-Zeit in 30-Sekunden-Intervallen',
          ),
          _buildArrow(context),
          _buildFlowStep(
            context,
            number: '2',
            title: 'HMAC-SHA1',
            description: 'Kryptographische Hashfunktion mit Secret Key',
          ),
          _buildArrow(context),
          _buildFlowStep(
            context,
            number: '3',
            title: 'Trunkierung',
            description: 'Extraktion von 4 Bytes aus dem Hash',
          ),
          _buildArrow(context),
          _buildFlowStep(
            context,
            number: '4',
            title: '6-stelliger Code',
            description: 'Modulo 1.000.000 für finalen Code',
          ),
        ],
      ),
    );
  }

  Widget _buildFlowStep(
    BuildContext context, {
    required String number,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer.withAlpha(200),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 13,
        top: 8,
        bottom: 8,
      ),
      child: Icon(
        Icons.arrow_downward,
        size: 20,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

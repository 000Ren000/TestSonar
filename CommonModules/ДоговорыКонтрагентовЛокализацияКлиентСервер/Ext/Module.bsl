﻿#Область СлужебныйПрограммныйИнтерфейс
//++ Локализация

Функция ИменаРеквизитовГОЗ() Экспорт
	СтруктураРеквизитов = "ВариантПлатежаГОЗ, ВыполненыОбязательстваПоДоговоруГОЗ, ГосударственныйКонтракт, Дата, Номер, 
		|Сумма, ДоговорСУчастникомГОЗ, ДоговорСсылка, КонтрагентЮрФизЛицо, КонтрактСЗаказчиком, 
		|ОплатаРасходовПоТарифамСГосрегулированием, ПлатежиПо275ФЗ, ПоддержкаПлатежей275ФЗ, ТипДоговора, ТипПлатежаФЗ275,
		|Организация, ОрганизацияПолучатель, СуммаТраншей, ХарактерДоговора, АдресПодтверждающихДокументовВоВременномХранилище";
	Возврат СтруктураРеквизитов
КонецФункции

// Параметры:
// 	Форма - ФормаКлиентскогоПриложения
//
Процедура УправлениеНастройкойГОЗ(Форма) Экспорт
	Форма.ВариантПлатежаГОЗ = ИнициализироватьВариантПлатежаГОЗ(Форма.Объект.ПлатежиПо275ФЗ,
		Форма.Объект.ДоговорСУчастникомГОЗ,
		Форма.Объект.ОплатаРасходовПоТарифамСГосрегулированием);
	Объект = Форма.Объект;
	
	СЗаказчиком =
		Объект.ТипДоговора = ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПокупателем")
		Или Ложь;
	
	СИсполнителем =
		Объект.ТипДоговора = ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПереработчиком2_5")
		Или Объект.ТипДоговора = ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПереработчиком2_5_ЕАЭС")
		//++ Устарело_Переработка24
		Или Объект.ТипДоговора = ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПереработчиком")
		//-- Устарело_Переработка24
		Или (Объект.ТипДоговора = ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПоставщиком")
		И Не Объект.ДоговорССамозанятым);
		
	ПоддержкаПлатежей275ФЗ = Форма.ПоддержкаПлатежей275ФЗ;
	ПоддержкаЭлектронногоАктированияВЕИС = Форма.ПоддержкаЭлектронногоАктированияВЕИС;
	
	Форма.Элементы.ИдентификаторГосКонтракта.Видимость = НЕ Форма.ПоддержкаПлатежей275ФЗ
		И СЗаказчиком;
			
	Форма.Элементы.ИностранныйИсполнительВУтвержденномПеречнеГОЗ.Видимость =
		(СИсполнителем
			И Форма.Объект.ДоговорСУчастникомГОЗ
			И Форма.КонтрагентЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицоНеРезидент"));
	
	Форма.Элементы.ЛокализацияГруппаНастроитьГОЗ.Видимость = (ПоддержкаПлатежей275ФЗ И (СЗаказчиком Или СИсполнителем))
		Или (ПоддержкаЭлектронногоАктированияВЕИС И СЗаказчиком);
	
	Если ЗначениеЗаполнено(Форма.Объект.ГосударственныйКонтракт) Тогда
		Форма.Элементы.ДекорацияНастроитьГК.Заголовок = Новый ФорматированнаяСтрока(Форма.Объект.ГосударственныйКонтракт.Наименование,,,, "НастроитьГОЗ");
	Иначе
		Форма.Элементы.ДекорацияНастроитьГК.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru='Настроить договор для исполнения госконтракта'"),,,, "НастроитьГОЗ");
	КонецЕсли;	
КонецПроцедуры

Функция ИнициализироватьВариантПлатежаГОЗ(ПлатежиПо275ФЗ, ДоговорСУчастникомГОЗ, ОплатаРасходовПоТарифамСГосрегулированием) Экспорт
	ВариантПлатежаГОЗ = 0;
	Если ПлатежиПо275ФЗ И ДоговорСУчастникомГОЗ Тогда
		ВариантПлатежаГОЗ = 1;
	ИначеЕсли ОплатаРасходовПоТарифамСГосрегулированием Тогда
		ВариантПлатежаГОЗ = 2;
	КонецЕсли;
	Возврат ВариантПлатежаГОЗ
КонецФункции

//-- Локализация

#КонецОбласти
